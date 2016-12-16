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




        var argumentationId = 1;

        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});

        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });


        if ($scope.argumentation.$resolved){
            $scope.boxClass = false;
        } else {
            $scope.boxClass = true;
        };


        $scope.nexta = function() {

            $scope.argumentation = Argumentation.get({ "argumentationId": 2 });
        }

    }
]);