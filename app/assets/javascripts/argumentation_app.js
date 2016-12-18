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
        $scope.main_argumentation_id = 1;
        $scope.loading = false;
        var argumentationId = 1;
        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        var ChildArgumentation = $resource('/get_child_argumentation/:argumentationId.json', {"argumentationId": "@argumentation_id"});
        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });
        $scope.boxClass = 1;

        //all functionss
        function setBoxClass(number){
            $scope.boxClass = number;
        }

        function get_argumentation(boxClass, id){
            $scope.loading = true;


            Argumentation.get({ "argumentationId": id }).$promise.then(function(argumentation) {
                $scope.argumentation = argumentation;
                $scope.loading = false;

                $timeout(function() {
                    setBoxClass(boxClass);
                }, 500);

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }


        function get_child_argumentation(boxClass, id){
            $scope.loading = true;


            ChildArgumentation.get({ "argumentationId": id }).$promise.then(function(argumentation) {
                $scope.argumentation = argumentation;
                $scope.loading = false;

                $timeout(function() {
                    setBoxClass(boxClass);
                }, 500);

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }


        $scope.nextargumentation = function(boxClass, id) {



            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_argumentation(boxClass + 1, id);
            }, 1000);
        }



        $scope.nextchildargumentation = function(boxClass, id) {



            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_child_argumentation(boxClass + 1, id);
            }, 1000);
        }

    }
]);
