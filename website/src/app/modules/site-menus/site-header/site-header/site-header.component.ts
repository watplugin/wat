import { Component, HostListener, OnInit } from '@angular/core';
import { BreakpointManagerService } from '@app/services/breakpoint-manager.service';
import { SettingsService } from '@src/_settings';

@Component({
  selector: 'app-site-header',
  templateUrl: './site-header.component.html',
  styleUrls: ['./site-header.component.css'],
})
export class SiteHeaderComponent implements OnInit {
  scrolled: boolean = false;

  constructor(public breakpointManager: BreakpointManagerService, public settings: SettingsService) {}

  ngOnInit(): void {}

  @HostListener('window:scroll', ['$event']) // for window scroll events
  onScroll() {
    this.scrolled = window.pageYOffset != 0;
  }

  readProperty(): string {
    let bodyStyles = window.getComputedStyle(document.body);
    return bodyStyles.getPropertyValue('--screen-type');
  }
}
