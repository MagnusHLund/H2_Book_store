<?php

namespace DavidsBookClub\Middleware;

use DavidsBookClub\Utils\Constants;
use DavidsBookClub\Utils\JwtManager;

class AuthenticationMiddleware
{
    public static function handleAuthentication($path)
    {
        $publicRoutes = Constants::getPublicRoutes();

        if (!in_array($path, $publicRoutes)) {
            if (isset($_SESSION['jwt'])) {
                JwtManager::decodeJwt($_SESSION['jwt']);
                return;
            }

            http_response_code(403);
            json_encode(["error" => "Permission denied"]);
            exit;
        }
    }
}
