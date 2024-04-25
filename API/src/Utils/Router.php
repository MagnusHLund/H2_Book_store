<?php

namespace MichaelsBookClub\Utils;

use MichaelsBookClub\Handlers\UserHandler;
use MichaelsBookClub\Handlers\ProductHandler;
use MichaelsBookClub\Handlers\OrderHandler;
use MichaelsBookClub\Handlers\CheckoutHandler;

class Router
{
    private $routes = [];

    public function __construct()
    {
        $baseUrl = "api/";

        $userHandler = new UserHandler;

        $userRoute = "User/";

        $productHandler = new ProductHandler;

        $productRoute = "Products/";

        $orderHandler = new OrderHandler;

        $orderRoute = "Orders/";

        $checkoutHandler = new CheckoutHandler;

        $checkoutRoute = "Checkout/";
        
        

        // Routes are made up in 3 parts. 1. Request type, 2. API url, 3. function to call
        $this->routes = [
            // User - Login
            ["POST", $baseUrl . $userRoute . "login", [$userHandler, "login"]],
            
            // User - Logout
            ["POST", $baseUrl . $userRoute . "logout", [$userHandler, "logout"]],

            // User - Create
            ["GET", $baseUrl . $userRoute . "create", [$userHandler, "CreateUser"]],
            
            // User - Update
            ["PUT", $baseUrl . $userRoute . "create/{id}", [$userHandler, "updateUser"]],

            // User - Delete
            ["DELETE", $baseUrl . $userRoute . "create", [$userHandler, "deleteUser"]]


            
        ];

        $this->routes = [
            // Product
            ["POST", $baseUrl . $productRoute . "Product", [$productHandler, "Product"]],

            // Product
            ["GET", $baseUrl . $productRoute . "Product", [$productHandler, "Product"]],
            
            // Product - Get product
            ["GET", $baseUrl . $productRoute . "product/{id}", [$productHandler, "getProductByID"]],

            // Product - Create product
            ["POST", $baseUrl . $productRoute . "product", [$productHandler, "createProduct"]],
            
            // Product - Update product
            ["PUT", $baseUrl . $productRoute . "product/{id}", [$productHandler, "updateProduct"]],
            
            // Product - Delete product
            ["DELETE", $baseUrl . $productRoute . "product/{id}", [$productHandler, "deleteProduct"]]
        ];

        $this->routes = [
            // Order
            ["POST", $baseUrl . $orderRoute . "order", [$orderHandler, "order"]],
            
            // Order - Get Order by ID
            ["GET", $baseUrl . $orderRoute . "order/{id}", [$orderHandler, "getOrderById"]],
            
            // Order - Get All Orders
            ["GET", $baseUrl . $orderRoute . "order", [$orderHandler, "getAllOrders"]]
        ];

        $this->routes = [
            // Checkout - Place Order
            ["POST", $baseUrl . $checkoutRoute . "placeOrder", [$checkoutHandler, "placeOrder"]],
            
            // Checkout - Get City from Zipcode
            ["GET", $baseUrl . $checkoutRoute . "getCityFromZipcode/{zipcode}", [$checkoutHandler, "getCityFromZipcode"]]
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
