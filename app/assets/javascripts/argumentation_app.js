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
        function setBoxClass(number){
            $scope.boxClass = number;
        }

        function get_argumentation(boxClass1){
            $scope.loading = true;


            Argumentation.get({ "argumentationId": 2 }).$promise.then(function(argumentation) {
                $scope.argumentation = argumentation;
                $scope.loading = false;

                $timeout(function() {
                    console.log("setBoxClass");
                    setBoxClass(boxClass1);
                }, 500);

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }


        $scope.nexta = function(boxClass) {


            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_argumentation(boxClass + 1);
            }, 1000);
        }

    }
]);
