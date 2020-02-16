#!/bin/sh
apt update >> /var/log/mujlog
apt -y install apache2 php php-mysql mariadb-client nmap >> /var/log/mujlog

rm /var/www/html/index.html

echo '#!/bin/bash
echo $(hostname)
' > /usr/lib/cgi-bin/hostname.sh
chmod +x /usr/lib/cgi-bin/hostname.sh

systemctl restart apache2

db=$(nmap -sn 10.0.0.0/24|grep dbvm| grep -o -E '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

mysql -ucounter -pcounter -Dcounter -h $db -e "INSERT INTO counter(hostname, count) VALUES ('$(hostname)', 0)" >> /var/log/mujlog

echo '<?php
$hostname = shell_exec("/usr/lib/cgi-bin/hostname.sh");
echo "<pre>$hostname</pre>";' > /var/www/html/index.php
echo \$servername = \""$db"\"\; >> /var/www/html/index.php
echo '$username = "counter";
$password = "counter";
$dbname = "counter";

// Create connection
$conn = new mysqli($servername, $username, $password, "$dbname");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 


$sql = "SELECT * FROM counter";
$result = $conn->query($sql);
// echo $result;
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["hostname"]. " - Value: " . $row["count"] . "<br>";
    }
} else {
    echo "0 results";
}

$sqlr = "SELECT count FROM counter WHERE hostname='$hostname'";
$rres = $conn->query($sqlr); 
$data = $rres->fetch_assoc();
$cnt = $data['count'];
echo $cnt;
$cnt +=1;
$sqlc = "UPDATE counter SET count=$cnt WHERE hostname='$hostname'";

if ($conn->query($sqlc) === TRUE) {
    echo "Record updated successfully";
} else {
    echo "Error updating record: " . $conn->error;
}

$conn->close();
?>
' >> /var/www/html/index.php
