var app = angular.module(
    'argumentation',[
    'ngRoute',
    'ngResource',
    'templates',
    'ngAnimate'
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

        $scope.boxClass = true;

        var argumentationId = 1;

        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});

        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });


        $scope.nexta = function() {

            $scope.boxClass = false;
            $scope.argumentation = Argumentation.get({ "argumentationId": 2 }).then(
                $scope.boxClass = true
            );
        }

    }
]);