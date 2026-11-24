"""Read Android binary XML fields without rewriting its string pool or encoding."""
import struct

def u16(b, p):
    return struct.unpack_from('<H', b, p)[0]

def u32(b, p):
    return struct.unpack_from('<I', b, p)[0]

def pool_strings(b, start):
    count = u32(b, start + 8)
    utf8 = bool(u32(b, start + 16) & 256)
    strings = start + u32(b, start + 20)
    offsets = start + u16(b, start + 2)
    def length(p, unit):
        bits = 8 * unit
        first = int.from_bytes(b[p:p+unit], 'little')
        flag = 1 << (bits-1)
        if first & flag:
            return ((first & (flag-1)) << bits) + int.from_bytes(b[p+unit:p+2*unit], 'little'), p+2*unit
        return first, p+unit
    result = []
    for i in range(count):
        p = strings + u32(b, offsets + 4*i)
        if utf8:
            _, p = length(p, 1)
            size, p = length(p, 1)
            result.append(bytes(b[p:p+size]).decode('utf-8'))
        else:
            size, p = length(p, 2)
            result.append(bytes(b[p:p+size*2]).decode('utf-16-le'))
    return result

def read_nodes(b):
    assert u16(b, 0) == 3 and u32(b, 4) == len(b)
    pos = u16(b, 2)
    pool, resmap, nodes = [], [], []
    while pos < len(b):
        kind, hsize, size = struct.unpack_from('<HHI', b, pos)
        assert 8 <= hsize <= size and pos + size <= len(b)
        if kind == 1:
            pool = pool_strings(b, pos)
        elif kind == 0x0180:
            resmap = [u32(b, i) for i in range(pos+hsize, pos+size, 4)]
        elif kind == 0x0102:
            ext = pos + hsize
            name = pool[u32(b, ext+4)]
            first, stride, count = struct.unpack_from('<HHH', b, ext+8)
            assert stride >= 20 and ext+first+stride*count <= pos+size
            attrs = {}
            for i in range(count):
                at = ext+first+i*stride
                ns, index, raw = struct.unpack_from('<III', b, at)
                typ, value = b[at+15], u32(b, at+16)
                attrs[pool[index]] = dict(
                    namespace=None if ns == 0xffffffff else pool[ns],
                    resource_id=resmap[index] if index < len(resmap) else None,
                    raw=None if raw == 0xffffffff else pool[raw],
                    type=typ, value=pool[value] if typ == 3 else value,
                    offset=at+16)
            nodes.append((name, attrs))
        pos += size
    assert pos == len(b) and nodes and nodes[0][0] == 'manifest'
    return nodes

def version_slot(b):
    attr = read_nodes(b)[0][1]['versionCode']
    assert attr['namespace'] == 'http://schemas.android.com/apk/res/android'
    assert attr['resource_id'] == 0x0101021b and attr['type'] == 0x10 and attr['raw'] is None
    return attr['offset']

