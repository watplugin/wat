import { Injectable } from '@angular/core';
import { CookieService } from 'ngx-cookie-service';
import { StyleManagerService } from './style-manager.service';

@Injectable({
  providedIn: 'root',
})
export class ThemeManagerService {
  private _currentTheme: string = 'light';

  constructor(private styleManagerService: StyleManagerService, private cookieService: CookieService) {
    this.currentTheme = cookieService.check('theme') ? cookieService.get('theme') : 'light';
  }

  set currentTheme(theme: string) {
    this._currentTheme = theme;
    this.cookieService.set('theme', this._currentTheme);
    this.styleManagerService.setStyle('theme', this._currentTheme + '.css');
  }

  get currentTheme() {
    return this._currentTheme;
  }
}
