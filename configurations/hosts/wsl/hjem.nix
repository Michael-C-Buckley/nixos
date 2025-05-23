{self, ...}: {
    hjem.users.michael = {
        apps = {
            browsers.librewolf.enable = true;
            editors.nvf.package = self.packages.${system}.nvf-default;
        };
    };
}