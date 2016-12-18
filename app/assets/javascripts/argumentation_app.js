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
        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });
        $scope.argumentcontent = {"description":"<-- choose Argument", "title": "Argument"};
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
                $scope.argumentcontent = {"description":"<-- choose Argument", "title": "Argument"};

                $timeout(function() {
                    setBoxClass(boxClass);
                }, 500);

            }, function(reason) {
                alert('Failed: ' + reason);
            });

        }

        $scope.getcontent = function(argument){
            $scope.argumentcontent = argument;
        }



        $scope.nextargumentation = function(boxClass, id) {

            $scope.boxClass = boxClass;

            setTimeout(function() {
                $anchorScroll();
                get_argumentation(boxClass + 1, id);
            }, 1000);
        }


    }
]);
