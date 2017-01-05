app = angular.module(
    'argumentationcontroller');

app.directive('myArgumentations', function() {
    return {
        templateUrl: "argumentation/myargumentations.html",
        controller: "MyArgumentationShowController"
    };
});