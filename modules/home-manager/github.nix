{
  programs.git = {
    enable = true;

    userName = "Logan Foster";
    userEmail = "zup7mn@virginia.edu";

    includes = [
      {
        condition = "gitdir:~/work/";
        contents = {
          user.name = "Logan Foster";
          user.email = "logan@truepathvision.com";
        };
      }
    ];
  };
}
