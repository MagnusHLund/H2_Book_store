<?php

namespace DavidsBookClub\Middleware;

use DavidsBookClub\Utils\Constants;

class CorsMiddleware
{
    public static function handleCors()
    {
        self::validateOrigin();
        self::validateRequest();
    }

    private static function validateOrigin()
    {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        $allowedOrigins = Constants::getAllowedOrigins();

        if (!empty($origin) && in_array($origin, $allowedOrigins)) {
            header("Access-Control-Allow-Origin: {$origin}");
            header("Access-Control-Allow-Credentials: true");
            header("Access-Control-Max-Age: 86400");
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
            header("Access-Control-Allow-Headers: Content-Type, Authorization");
        } else {
            http_response_code(401);
            echo json_encode(["error" => "Failed CORS validation!"]);
            exit;
        }
    }

    private static function validateRequest()
    {
        $requestMethod = $_SERVER['REQUEST_METHOD'] ?? '';

        if ($requestMethod == 'OPTIONS') {
            $requestHeaders = $_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'] ?? '';

            if (!empty($requestMethod)) {
                header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
            }

            if (!empty($requestHeaders)) {
                header("Access-Control-Allow-Headers: {$requestHeaders}");
            }

            http_response_code(200);
            exit;
        }
    }
}
