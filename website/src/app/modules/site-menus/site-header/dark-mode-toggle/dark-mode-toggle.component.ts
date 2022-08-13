import { OverlayContainer } from '@angular/cdk/overlay';
import { Component, HostBinding, OnInit } from '@angular/core';
import { MatSlideToggleChange } from '@angular/material/slide-toggle';
import { ThemeManagerService } from '@app/services/theme-manager.service';

@Component({
  selector: 'app-dark-mode-toggle',
  templateUrl: './dark-mode-toggle.component.html',
  styleUrls: ['./dark-mode-toggle.component.css'],
})
export class DarkModeToggleComponent implements OnInit {
  constructor(private themeManager: ThemeManagerService) {
    this.isDark = this.themeManager.currentTheme == 'dark';
  }

  isDark: boolean = false;

  ngOnInit(): void {}

  onChange($event: MatSlideToggleChange) {
    this.isDark = $event.checked;
    this.themeManager.currentTheme = this.isDark ? 'dark' : 'light';
  }
}
