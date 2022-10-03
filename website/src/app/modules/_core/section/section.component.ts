import { Component, OnInit, Input, Attribute, Optional, ElementRef } from '@angular/core';

@Component({
  selector: 'app-section',
  templateUrl: './section.component.html',
  styleUrls: ['./section.component.css'],
})
export class SectionComponent implements OnInit {
  @Input() title: string = '';
  @Input() color: string = 'blank';
  @Input() bgImage: string = '';
  @Input() bgRepeatMode: string = '';
  @Input() bgPosition: string = '';

  last: boolean;
  dogEar: boolean;
  fullPage: boolean;
  fullWidth: boolean;
  shadow: boolean;

  constructor(
    private elementRef: ElementRef,
    @Optional() @Attribute('last') last: any,
    @Optional() @Attribute('dog-ear') dogEar: any,
    @Optional() @Attribute('full-page') fullPage: any,
    @Optional() @Attribute('full-width') fullWidth: any,
    @Optional() @Attribute('shadow') shadow: any,
  ) {
    this.last = last != undefined;
    this.dogEar = dogEar != undefined;
    this.fullPage = fullPage != undefined;
    this.fullWidth = fullWidth != undefined;
    this.shadow = shadow != undefined;
  }

  ngOnInit(): void {
    // Avoids race condition of last being added after construction (ie. when using ngIf, etc.).
    this.last = this.elementRef.nativeElement.hasAttribute('last');
    this.dogEar = this.elementRef.nativeElement.hasAttribute('dog-ear');
    this.fullPage = this.elementRef.nativeElement.hasAttribute('full-page');
    this.fullWidth = this.elementRef.nativeElement.hasAttribute('full-width');
    this.shadow = this.elementRef.nativeElement.hasAttribute('shadow');
  }

  //transparent-background-color
  getBgStyle(): Object {
    return {
      ...(this.bgImage && {
        'background-image': 'linear-gradient(var(--background-color), #00000000), url(' + this.bgImage + ')',
      }),
      ...(this.bgRepeatMode !== '' && { 'background-repeat': this.bgRepeatMode, 'background-size': 'auto' }),
      ...(this.bgPosition !== '' && { 'background-position': this.bgPosition }),
    };
  }
}
