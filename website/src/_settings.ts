import { Injectable } from '@angular/core';
import arrowDownCircleFill from '@iconify/icons-bi/arrow-down-circle-fill';
import github from '@iconify/icons-simple-icons/github';
import kofi from '@iconify/icons-simple-icons/ko-fi';
import { PageLink } from '@src/app/classes/pagelink';

// Settings for the entire site.
// Edit these if you need to make minor tweaks

@Injectable({
  providedIn: 'root',
})
export class SettingsService {
  public General = new (class {
    // Currently available pages on the navigation menus

    //  Note that removing a link does not mean the page is gone -- it only means
    //  you won't see it on the navigational menu. You can still access the page
    //  using it's URL.

    //  Format: new PageLink("Link Name", "url_relative_to_the_site");
    public pageLinks: PageLink[] = [
      // new PageLink('Home', 'home'),
    ];

    // Social media links
    public kofiLink: string = 'https://ko-fi.com/Q5Q51D9K5';
    public githubLink: string = 'https://github.com/AlexDarigan/WAT';

    public icons = {
      github,
      kofi,
      arrowDownCircleFill,
    };
  })();
}
