angular.module(
    'argumentationcontroller').config([
    "$routeProvider",
    function($routeProvider) {
        $routeProvider.when("/overview/",{
            templateUrl: "argumentation/overview.html"
        }).when("/search",{
            controller: "ArgumentationSearchController",
            templateUrl: "argumentation/search.html"
        }).when("/edit/:id", {
            controller: "ArgumentationEditController",
            templateUrl: "argumentation/edit.html"
        }).when("/:id", {
            controller: "ArgumentationShowController",
            templateUrl: "argumentation/show.html"
        }).otherwise("/overview",{
            templateUrl: "argumentation/overview.html"
        });
    }
]);