import { Component, OnInit } from '@angular/core';
import { SettingsService } from '@src/_settings';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.css'],
  host: {
    class: 'page',
  },
})
export class HomePageComponent implements OnInit {
  constructor(public settings: SettingsService) {}

  ngOnInit(): void {}
}
