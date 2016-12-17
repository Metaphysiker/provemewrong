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




        var argumentationId = 1;

        var Argumentation = $resource('/argumentations/:argumentationId.json', {"argumentationId": "@argumentation_id"});

        $scope.argumentation = Argumentation.get({ "argumentationId": argumentationId });


            $scope.boxClass = 1;


        function waitforresolved() {
            return $q(function(resolve, reject) {
                setTimeout(function() {
                    if($scope.argumentation.$resolved == true) {
                        resolve();
                    } else {
                        reject();
                        alert("nope");
                    }
                }, 1500);
            });
        }



        $scope.nexta = function() {


            $scope.boxClass = 2
            setTimeout(function() {

            }, 2000);



            Argumentation.get({ "argumentationId": 2 }).$promise.then(function(argumentation) {

                $scope.argumentation = argumentation;

                var promise2 = waitforresolved();
                promise2.then(function(){
                    $scope.boxClass = 3;
                });



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