<?php

namespace DavidsBookClub\Utils;

use DavidsBookClub\Utils\Constants;
use Firebase\JWT\Key;
use Firebase\JWT\JWT;

class JwtManager
{
    public static function encodeJwt($userInfo)
    {
        $payload = [
            'iss' => 'DavidsBookClub',
            'sub' => $userInfo,
            'iat' => time(),
            'exp' => time() + 86400 // 1 day
        ];
        return JWT::encode(
            $payload,
            Constants::getJwtSecretKey(),
            'HS256',
            Constants::getKid()
        );
    }

    public static function decodeJwt()
    {
        $keyArray = new Key(Constants::getJwtSecretKey(), 'HS256');
        return JWT::decode($_SESSION['user_jwt'], $keyArray);
    }
}
