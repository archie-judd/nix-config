{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      archie = {
        containersForce = true;
        containers = {
          dev = {
            color = "green";
            id = 1;
            icon = "circle";
          };
          prod = {
            color = "red";
            id = 2;
            icon = "circle";
          };
          google = {
            color = "blue";
            id = 3;
            icon = "circle";
          };
        };
        bookmarks = [{
          name = "toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "Okta";
              url =
                "https://lunarenergy.okta.com/app/UserHome?iss=https%3A%2F%2Flunarenergy.okta.com&session_hint=AUTHENTICATED";
            }
            {
              name = "fp-ts | Modules";
              url = "https://gcanti.github.io/fp-ts/modules/";
            }
            {
              name = "bob";
              url = "https://app.hibob.com/home";
            }
            {
              name = "lattice";
              url =
                "https://lunarenergy.latticehq.com/users/dadfe795-014e-400a-8edd-3f7ea01041fb/";
            }
            {
              name = "AWS";
              bookmarks = [
                {
                  name = "Start";
                  url = "https://d-9067b5cea1.awsapps.com/start#/";
                }
                {
                  name = "Home";
                  url =
                    "https://eu-west-1.console.aws.amazon.com/console/home?region=eu-west-1";
                }
              ];
            }
            {
              name = "Github";
              bookmarks = [
                {
                  name = "Home";
                  url = "https://github.com";
                }
                {
                  name = "gridshare-edge";
                  url = "https://github.com/lunar-energy/gridshare-edge";
                }
                {
                  name = "gridshare_planning";
                  url = "https://github.com/lunar-energy/gridshare-planning";
                }
              ];
            }
            {
              name = "Partner Portal";
              bookmarks = [
                {
                  name = "US - Prod";
                  url = "https://partner.us.mygridshare.com";
                }
                {
                  name = "US - Dev";
                  url = "https://partner.dev0.us.mygridshare.com";
                }
                {
                  name = "EU - Prod";
                  url = "https://partner.mygridshare.com";
                }
                {
                  name = "EU - Dev";
                  url = "https://partner.dev0.mygridshare.com";
                }
              ];
            }
            {
              name = "Grafana";
              bookmarks = [
                {
                  name = "US - Prod";
                  url =
                    "https://lunarenergy.okta.com/home/oidc_client/0oaer8tre18jcpFdq696/aln177a159h7Zf52X0g8";
                }
                {
                  name = "US - Dev";
                  url =
                    "https://lunarenergy.okta.com/home/oidc_client/0oaer8e90nj8BdoSY696/aln177a159h7Zf52X0g8";
                }
                {
                  name = "EU - Prod";
                  url =
                    "https://lunarenergy.okta.com/home/oidc_client/0oaer8ay0Nkn3SFhH696/aln177a159h7Zf52X0g8";
                }
                {
                  name = "EU - Dev";
                  url =
                    "https://lunarenergy.okta.com/home/oidc_client/0oaer71v3mc4BMRTk696/aln177a159h7Zf52X0g8";
                }
              ];
            }
            {
              name = "Atlassian";
              bookmarks = [
                {
                  name = "Jira";
                  url = "https://lunarenergy.atlassian.net/jira/your-work";
                }
                {
                  name = "Confluence";
                  url = "https://lunarenergy.atlassian.net/wiki/home";
                }
              ];
            }

            {
              name = "News";
              bookmarks = [
                {
                  name = "BBC";
                  url = "https://www.bbc.co.uk/news";
                }
                {
                  name = "Financial Times";
                  url = "https://www.ft.com";
                }

              ];
            }
          ];
        }];
      };
    };
  };

}
