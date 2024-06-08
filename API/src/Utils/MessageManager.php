<?php

namespace DavidsBookClub\Utils;

/**
 * This class exists to ensure that each message being sent out of the API, is the same format. It also has the ability to log out an error message, to a log file.
 */
class MessageManager
{
    /**
     * This function is responsible for sending out a successful API response, to the caller, as a json object.
     * @param string $responseMessage The "result" message which will be received by the caller.
     */
    public static function sendSuccess($responseMessage)
    {
        http_response_code(200);
        echo json_encode(["Success" => true, "result" => $responseMessage]);
    }

    /**
     * This function is responsible for sending out error messages, to the caller, as a json object.
     * @param string $responseMessage The "result" message which will be received by the caller.
     * @param int $responseCode A valid http error code, such as 404, 500, 401. www.semrush.com/blog/http-status-codes
     * @param string|null $logMessage Optional parameter. If a value is provided, a log file is created with the given message.
     */
    public static function sendError($responseMessage, $responseCode, $logMessage = null)
    {
        if ($logMessage) {
            self::createLog($logMessage);
        }

        http_response_code($responseCode);
        echo json_encode(["Success" => false, "result" => $responseMessage]);
        exit;
    }

    /**
     * This function creates a log file, with a given message inside. The log files will be located within the /API/logs/ directory. Log file names are the timestamp of their creation.
     * @param string $logMessage Message to put into the log file
     */
    public static function createLog($logMessage)
    {
        $logFolder = __DIR__ . "../../logs/";

        $current_time = date("Y-m-d H-i-s");
        $logName = $current_time . ".txt";

        $logFile = $logFolder . $logName;

        // Logs out an error with the $logMessage as file content. The "3" means its a logged to a file. $logFile is the file destination and file name.
        error_log($logMessage, 3, $logFile);
    }
}
