import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-home-page',
  templateUrl: './home-page.component.html',
  styleUrls: ['./home-page.component.css'],
  host: {
    class: 'page',
  },
})
export class HomePageComponent implements OnInit {
  ngOnInit(): void {}
}
