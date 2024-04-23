<?php

namespace MichaelsBookClub\Utils;

class Constants
{
    public function getDatabaseInfo()
    {
        return array(
            "DB_HOST" => $_ENV['DB_HOST'],
            "DB_USER" => $_ENV['DB_USER'],
            "DB_PASS" => $_ENV['DB_PASSWORD'],
            "DB_NAME" => $_ENV['DB_DATABASE'],
        );
    }

    public function getAllowedOrigins()
    {
        return $_ENV['ALLOWED_HOSTS'];
    }
}
