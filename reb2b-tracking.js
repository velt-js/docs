// Reb2b visitor tracking script
!function(key) {
  if (window.reb2b) return;
  window.reb2b = {loaded: true};
  var s = document.createElement("script");
  s.async = true;
  s.src = "https://b2bjsstore.s3.us-west-2.amazonaws.com/b/" + key + "/" + key + ".js.gz";
  document.getElementsByTagName("script")[0].parentNode.insertBefore(s, document.getElementsByTagName("script")[0]);
}("Q6J2RHMPWQ6D");

