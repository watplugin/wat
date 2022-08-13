import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-full-page-header',
  templateUrl: './full-page-header.component.html',
  styleUrls: ['./full-page-header.component.css'],
})
export class FullPageHeaderComponent implements OnInit {
  @Input() bgImage: string = '';
  @Input() color: string = 'primary';
  @Input() gradient: string = '';
  @Input() bgRepeatMode: string = '';
  @Input() bgPosition: string = '';

  constructor() {}

  ngOnInit(): void {}

  getBgStyle(): Object {
    let gradient = this.gradient;
    if (gradient == '') gradient = 'var(--background-color), #00000000';
    return {
      'background-image': 'linear-gradient(to bottom, ' + gradient + '), url(' + this.bgImage + ')',
      ...(this.bgRepeatMode !== '' && { 'background-repeat': this.bgRepeatMode, 'background-size': 'auto' }),
      ...(this.bgPosition !== '' && { 'background-position': this.bgPosition }),
    };
  }
}
