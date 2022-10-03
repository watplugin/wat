import { Attribute, Component, ElementRef, OnInit, Optional } from '@angular/core';

@Component({
  selector: 'app-sub-section',
  templateUrl: './sub-section.component.html',
  styleUrls: ['./sub-section.component.css'],
})
export class SubSectionComponent implements OnInit {
  last: boolean;

  constructor(private elementRef: ElementRef, @Optional() @Attribute('last') lastAttr: any) {
    this.last = lastAttr != undefined;
  }

  ngOnInit(): void {
    // Avoids race condition of last being added after construction (ie. when using ngIf, etc.).
    this.last = this.elementRef.nativeElement.hasAttribute('last');
  }
}
