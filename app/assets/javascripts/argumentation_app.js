var app = angular.module(
    'argumentation',[
    'ngRoute',
    'ngResource',
    'templates'
]);

app.config([
    "$routeProvider",
    function($routeProvider) {
        $routeProvider.when("/", {
            controller: "ArgumentationController",
            templateUrl: "argumentation_show.html"
        });
    }
]);


app.controller("ArgumentationController", [
    '$scope', '$resource',
    function($scope, $resource) {

        var argumentationId = 1;

        var Customer = $resource('/argumentation/:argumentationId.json', {"argumentationId": "@argumentation_id"});

        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });

    }
]);