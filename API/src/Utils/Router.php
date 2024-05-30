<?php

namespace davidsBookClub\Utils;

use davidsBookClub\Handlers\ProductsHandler;
use davidsBookClub\Handlers\OrdersHandler;
use davidsBookClub\Handlers\UsersHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/v1/";

        $userHandler = new UsersHandler;
        $userRoute = "User/";

        $productHandler = new ProductsHandler;
        $productRoute = "Products/";

        $orderHandler = new OrdersHandler;
        $orderRoute = "Orders/";
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
