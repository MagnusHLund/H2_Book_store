<?php

namespace MichaelsBookClub\Utils;

use MichaelsBookClub\Handlers\LoginHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/";

        $loginHandler = new LoginHandler;

        $loginRoute = "login/";

        // Routes are made up in 3 parts. 1. Request type, 2. API url, 3. function to call
        $this->routes = [
            // Login
            ["POST", $baseUrl . $loginRoute . "login", [$loginHandler, "login"]]
        ];
    }

    public function handleRequest($method, $path, $requestBody)
    {
        foreach ($this->routes as $route) {
            list($routeMethod, $routePath, $handler, $params) = $route + [null, null, null, []];
            if ($method === $routeMethod && $path === $routePath) {
                call_user_func_array([$handler[0], $handler[1]], [[$requestBody], $params]);
                return;
            }
        }

        http_response_code(404);
        echo json_encode(["error" => "Route does not exist!"]);
        exit;
    }
}
