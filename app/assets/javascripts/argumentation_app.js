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
    '$scope', '$resource', '$q',
    function($scope, $resource, $q) {


        $scope.loading = false;
        var argumentationId = 1;

        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});

        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });


        $scope.boxClass = 1;


        $scope.nexta = function() {


            $scope.boxClass = 2;
            $scope.loading = true;

            Argumentation.get({ "argumentationId": 2 }).$promise.then(function(argumentation) {
                $scope.loading = false;
                $scope.argumentation = argumentation;
                $scope.boxClass = 3;

            }, function(reason) {
                alert('Failed: ' + reason);
            });


            //Argumentation.get({ "argumentationId": 2 }).success(function(){
             //   $scope.boxClass = 3;
           // });
           // $scope.argumentation = Argumentation.get({ "argumentationId": 2 });
        }

    }
]);