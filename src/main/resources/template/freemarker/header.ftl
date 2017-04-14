<!DOCTYPE html>
<html lang="en" ng-app="collectEarth">
    <head>
        <title>Collect Earth Online</title>
        <meta charset="utf-8">
        <meta content="Collect Earth Online is an Image Analysis Crowdsourcing Platform by Spatial Informatics Group" name="description">
        <meta content="collect earth online image analysis crowdsourcing platform asia mekong cambodia thailand laos vietnam myanmar SIG spatial informatics group" name="keywords">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <link href="favicon.ico" rel="shortcut icon">
        <link href="css/cssreset-min.css" rel="stylesheet" type="text/css">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:100,400,700" rel="stylesheet" type="text/css">
        <link href="https://fonts.googleapis.com/css?family=Oswald:normal" rel="stylesheet" type="text/css">
        <link href="css/openlayers_3.13.0.css" rel="stylesheet" type="text/css">
        <link href="css/stylesheet.css" rel="stylesheet" type="text/css">
        <!--[if lt IE 9]>
          <script type="text/javascript" src="js/html5shiv.js"></script>
        <![endif]-->
        <script type="text/javascript" src="js/angular.min.js"></script>
        <script type="text/javascript" src="js/openlayers_3.13.0.js"></script>
        <script type="text/javascript" src="js/map_utils.js"></script>
        <script type="text/javascript" src="js/utils.js"></script>
        <script type="text/javascript" src="js/ceo_sample_data.js"></script>
        <!-- <script type="text/javascript" src="js/angular-route.min.js"></script> -->
        <script type="text/javascript" src="js/collect-earth.js"></script>
        <!----------------------------------------------------------------->
        <!-- BEGIN: Billy's GEODASH libraries, FIXME: Simplify this list -->
        <!----------------------------------------------------------------->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
        <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">
        <link href="css/geo-dash.css" rel="stylesheet">
        <script src="js/ie-emulation-modes-warning.js"></script>
        <!-- Respond.js for IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery-3.1.1.min.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://cdn.rawgit.com/nnattawat/flip/master/dist/jquery.flip.min.js"></script>
        <!--------------------------------------------------------------->
        <!-- END: Billy's GEODASH libraries, FIXME: Simplify this list -->
        <!--------------------------------------------------------------->
    </head>
    <body ng-controller="ctlBody">
        <header>
            <div id="logos">
                <img id="usaid" src="img/usaid.png">
                <img id="nasa" src="img/nasa.png">
                <img id="adpc" src="img/ADPC.jpg">
                <img id="servir" src="img/servir.png">
            </div>
            <nav style="visibility:${nav_visibility}">
                <ul>
                    <#if role == "admin">
                        <#list ["Home", "About", "Account", "Dashboard", "Admin"] as url>
                            <#if navlink == url>
                                <li><a class="active-link" href="${url?lower_case}">${url}</a></li>
                            <#else>
                                <li><a href="${url?lower_case}">${url}</a></li>
                            </#if>
                        </#list>
                    <#elseif role == "user">
                        <#list ["Home", "About", "Account", "Dashboard"] as url>
                            <#if navlink == url>
                                <li><a class="active-link" href="${url?lower_case}">${url}</a></li>
                            <#else>
                                <li><a href="${url?lower_case}">${url}</a></li>
                            </#if>
                        </#list>
                    <#else>
                        <#list ["Home", "About"] as url>
                            <#if navlink == url>
                                <li><a class="active-link" href="${url?lower_case}">${url}</a></li>
                            <#else>
                                <li><a href="${url?lower_case}">${url}</a></li>
                            </#if>
                        </#list>
                    </#if>
                </ul>
            </nav>
            <div id="login-info" style="visibility:${nav_visibility}">
                <p>
                    <#if username??>
                        <#if navlink == "Logout">
                            Logged in as ${username} <a class="active-link" href="logout">Logout</a>
                        <#else>
                            Logged in as ${username} <a href="logout">Logout</a>
                        </#if>
                    <#else>
                        <#if navlink == "Login">
                            <a class="active-link" href="login">Login</a>
                        <#else>
                            <a href="login">Login</a>
                        </#if>
                    </#if>
                </p>
            </div>
        </header>
        <section id="content">
            <#list flash_messages>
                <div class="alert">
                    <#items as flash_message>
                        <p>${flash_message}</p>
                    </#items>
                </div>
            </#list>
