<?php
// Vulnerabilidad a Local File Inclusion (LFI)
$page = $_GET['page'] ?? 'home';
include("/var/www/html/vulnerable-site/" . $page . ".php");
?>