import { Component, OnInit } from '@angular/core';
import { SettingsService } from '@src/_settings';

@Component({
  selector: 'app-site-footer',
  templateUrl: './site-footer.component.html',
  styleUrls: ['./site-footer.component.css'],
})
export class SiteFooterComponent implements OnInit {
  constructor(public settings: SettingsService) {}

  ngOnInit(): void {}
}
