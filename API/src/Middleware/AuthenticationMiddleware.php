<?php

namespace DavidsBookClub\Middleware;

use DavidsBookClub\Utils\Constants;
use DavidsBookClub\Utils\MessageManager;
use DavidsBookClub\Utils\SecurityManager;

/**
 * Responsible for blocking traffic which does not have proper authentication, for the specific route.
 */
class AuthenticationMiddleware
{
    public static function handleAuthentication($path)
    {
        // Assigns an array, which has each of the routes that do not require authentication (public routes).
        $publicRoutes = Constants::getPublicRoutes();

        // Checks if the API call path is not a public route
        if (!in_array($path, $publicRoutes)) {
            if (isset($_COOKIE['jwt'])) {
                SecurityManager::decodeJwt($_COOKIE['jwt']);
                return;
            }

            // If there is no JWT token, get the IP address of the caller.
            // If the caller is using a proxy, get the original IP address instead of the proxy IP.
            $ipAddress = $_SERVER["HTTP_X_FORWARDED_FOR"] ?? $_SERVER['REMOTE_ADDR'];

            // Create a log message indicating that an attempt was made to access a private route without a JWT token, as well as returning an error to the caller.
            $logMessage = "$ipAddress Attempted to enter a private route, without having a JWT";
            MessageManager::sendError("Permission denied", 401, $logMessage);
        }
    }
}
