{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Logan Foster";
      user.email = "zup7mn@virginia.edu";
    };

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

  programs.lazygit.enable = true;
}
