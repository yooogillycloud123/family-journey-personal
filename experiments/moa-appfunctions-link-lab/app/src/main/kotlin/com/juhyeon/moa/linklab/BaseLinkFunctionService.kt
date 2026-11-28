package com.juhyeon.moa.linklab

import androidx.appfunctions.AppFunctionDeclaration
import androidx.appfunctions.AppFunctionService
import androidx.appfunctions.AppFunctionServiceEntryPoint
import androidx.appfunctions.AppFunctionInvalidArgumentException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@AppFunctionServiceEntryPoint(serviceName = "LinkFunctionService", appFunctionXmlFileName = "moa_link_function_service")
abstract class BaseLinkFunctionService : AppFunctionService() {
    /** Check synthetic fixture state only. Does not start a model or send any private data. */
    @AppFunctionDeclaration(isDescribedByKDoc = true)
    suspend fun demoStatus(): String = withContext(Dispatchers.IO) { StoreProvider.get(this@BaseLinkFunctionService).status() }

    /** Claim the single synthetic apple scene after the user enabled the lab. Returns a job and lease or NO_JOB. */
    @AppFunctionDeclaration(isDescribedByKDoc = true)
    suspend fun claimDemo(): String = withContext(Dispatchers.IO) { StoreProvider.get(this@BaseLinkFunctionService).claim() }

    /**
     * Save the synthetic English sentence and Korean translation. Not a production learning card.
     * @param job exact job ID from claimDemo
     * @param lease exact unexpired lease from claimDemo
     * @param english one plain English sentence, max 512 characters
     * @param korean its Korean translation, max 512 characters
     */
    @AppFunctionDeclaration(isDescribedByKDoc = true)
    suspend fun submitDemo(job: String, lease: String, english: String, korean: String): String = withContext(Dispatchers.IO) {
        try { StoreProvider.get(this@BaseLinkFunctionService).submit(job, lease, english, korean) }
        catch (e: IllegalArgumentException) { throw AppFunctionInvalidArgumentException(e.message ?: "Invalid") }
        catch (e: IllegalStateException) { throw AppFunctionInvalidArgumentException(e.message ?: "Invalid state") }
    }
}
