import { AfterViewInit, Directive, ElementRef, Input, OnDestroy } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';

@Directive({
  selector: '[breakable-styles]',
})
export class BreakableStylesDirective implements AfterViewInit, OnDestroy {
  @Input() style: string = '';
  @Input('prebreak-style') preBreakStyle: string = '';
  @Input('break-style') breakStyle: string = '';
  @Input('break-on') breakOn: string = '';

  isBreaking: boolean = false;

  resizeObserver?: ResizeObserver;

  constructor(private el: ElementRef, private doms: DomSanitizer) {}

  ngOnDestroy(): void {
    this.resizeObserver?.disconnect();
  }

  ngAfterViewInit(): void {
    const args = this.breakOn.split(' ');
    if (args.length < 3) return;
    const type = args[0];
    const operator = args[1];
    const targetValue = this.getValueFromString(args[2]);

    this.updateStyle();

    switch (type) {
      case 'bottom':
      case 'left':
      case 'top':
      case 'right':
      case 'width':
      case 'height':
      case 'x':
      case 'y':
        this.resizeObserver = new ResizeObserver((entries, observer) => {
          for (const entry of entries) {
            const comparedToValue = entry.contentRect[type];
            this.isBreaking = this.compareValues(comparedToValue, targetValue, operator);

            this.updateStyle();
          }
        });

        this.resizeObserver.observe(this.el.nativeElement);

        return;
      default:
        return;
    }
  }

  getValueFromString(value: string) {
    if (value === 'true') return true;
    if (value === 'false') return false;
    return Number(value);
  }

  compareValues(valueOne: any, valueTwo: any, operator: string) {
    switch (operator) {
      case '>':
        return valueOne > valueTwo;
      case '>=':
        return valueOne >= valueTwo;
      case '<':
        return valueOne < valueTwo;
      case '<=':
        return valueOne <= valueTwo;
      case '==':
        return valueOne == valueTwo;
      case '!=':
        return valueOne != valueTwo;
      case '===':
        return valueOne === valueTwo;
      case '!==':
        return valueOne !== valueTwo;
      default:
        return false;
    }
  }

  updateStyle() {
    const styleText = this.style + (this.isBreaking ? this.breakStyle : this.preBreakStyle);
    this.el.nativeElement.style.cssText = styleText;
  }
}
