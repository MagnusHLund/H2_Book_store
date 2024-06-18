<?php

namespace DavidsBookClub\Middleware;

use DavidsBookClub\Utils\Constants;
use DavidsBookClub\Utils\MessageManager;

class CorsMiddleware
{
    /**
     * Class entry point, which validates both the origin and handles the preflight headers, by calling the appropriate functions.
     */
    public static function handleCors()
    {
        self::validateOrigin();
        self::handlePreflightRequest();
    }

    /**
     * This function checks if the request origin is allowed to call the API.
     */
    private static function validateOrigin()
    {
        // Gets the origin from the request header.
        $origin = $_SERVER['HTTP_ORIGIN'] ?? 'undefined';

        // Assigns an array which has the list of allowed origins.
        $allowedOrigins = Constants::getAllowedOrigins();

        // sets CORS headers, if the origin is in the $allowedOrigins array, else an error is returned to the caller.
        if (in_array($origin, $allowedOrigins)) {
            header("Access-Control-Allow-Origin: {$origin}");
            header("Access-Control-Allow-Credentials: true");
            header("Access-Control-Max-Age: 86400");
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
            header("Access-Control-Allow-Headers: Content-Type, Authorization");
        } else {
            $logMessage = "Attempted connection from unknown origin: $origin";
            MessageManager::sendError("Failed CORS validation", 401, $logMessage);
            exit;
        }
    }

    /**
     * Sets the appropriate headers for the preflight network request, sent by the browser.
     */
    private static function handlePreflightRequest()
    {
        // Get the request method type, from the network request
        $requestMethod = $_SERVER['REQUEST_METHOD'] ?? '';

        // Checks if the header is 'OPTIONS'.
        if ($requestMethod == 'OPTIONS') {
            $requestHeaders = $_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'] ?? '';

            // Allow API calls with the GET, POST, and OPTIONS methods.
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

            // If $requestHeaders is not empty, then set Access control headers
            if (!empty($requestHeaders)) {
                header("Access-Control-Allow-Headers: {$requestHeaders}");
            }

            http_response_code(200);
            exit;
        }
    }
}
