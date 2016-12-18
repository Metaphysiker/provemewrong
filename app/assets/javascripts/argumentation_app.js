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
    '$scope', '$resource', '$q','$timeout', '$anchorScroll',
    function($scope, $resource, $q, $timeout, $anchorScroll) {

        // all vars and assignments
        $scope.loading = false;
        var argumentationId = 1;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });
        $scope.boxClass = 1;

        //all functionss
        function setBoxClass(){
            $scope.boxClass = 3;
        }

        function get_child_argumentation(){
            $scope.loading = true;


            Argumentation.get({ "argumentationId": 2 }).$promise.then(function(argumentation) {
                $scope.argumentation = argumentation;
                $scope.loading = false;

                $timeout(function() {
                    console.log("setloading");
                    setBoxClass();
                }, 1000);

            }, function(reason) {
                alert('Failed: ' + reason);
            });
            console.log("Timeout occurred1");

        }


        $scope.nexta = function() {


            $scope.boxClass = 2;

            setTimeout(function() {
                $anchorScroll();
                console.log("Timeout occurred2");
                get_child_argumentation();
            }, 2000);
        }

    }
]);
