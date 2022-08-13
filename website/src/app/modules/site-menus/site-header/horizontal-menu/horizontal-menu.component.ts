import { Component, Input, OnInit } from '@angular/core';
import { PageLink } from '@src/app/classes/pagelink';

@Component({
  selector: 'app-horizontal-menu',
  templateUrl: './horizontal-menu.component.html',
  styleUrls: ['./horizontal-menu.component.css'],
})
export class HorizontalMenuComponent implements OnInit {
  @Input() pageLinks: PageLink[] = [];

  constructor() {}

  ngOnInit(): void {}
}
