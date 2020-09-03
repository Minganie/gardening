<?php
require_once __DIR__ . '/../vendor/autoload.php';

$loader = new Twig_Loader_Filesystem(__DIR__ . '/views');
$twig = new Twig_Environment($loader, ['debug'=>true]);
$twig->addExtension(new \Twig\Extension\DebugExtension());

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

session_start();

$params = array(
    'name' => "Mel's Gardening Cliffnotes",
    'logged' => !empty($_SESSION['username']),
    'groups' => array(),
    'crops' => array()
);

$host = 'localhost';
$db = 'gardening';

$user = $_ENV['UN'];
$pw = $_ENV['PW'];

try
{
    $conn_string = "pgsql:host=$host;port=5432;dbname=$db;user=$user;password=$pw";
    // error_log($conn_string);
    $conn = new PDO($conn_string);
    $conn->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
    
    // list of crops for css
    $stmt = $conn->prepare("SELECT * FROM crops");
    $stmt->execute();
    $crops = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $params['crops'] = $crops;
    
    // groups of plots for display
    $stmt = $conn->prepare("SELECT * FROM vgroups");
    $stmt->execute();
    $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($groups as &$group) {
        $group['plots'] = json_decode($group['plots'], true);
    }
    unset($group);
    $params['groups'] = $groups;
    
    $conn = null;
}
catch(Exception $e)
{
    error_log("Connection error: ".$e->getMessage());
}

echo $twig->render('main.html', $params);