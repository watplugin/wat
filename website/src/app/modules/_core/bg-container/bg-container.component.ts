import { Attribute, Component, Input, OnInit, Optional } from '@angular/core';

@Component({
  selector: 'app-bg-container',
  templateUrl: './bg-container.component.html',
  styleUrls: ['./bg-container.component.css'],
})
export class BgContainerComponent implements OnInit {
  @Input() color: string = 'blank';

  fullPage: boolean;

  constructor(@Optional() @Attribute('full-page') fullPage: any) {
    this.fullPage = fullPage != undefined;
  }

  ngOnInit(): void {}
}
