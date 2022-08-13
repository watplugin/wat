import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer, SafeHtml, SafeStyle, SafeScript, SafeUrl, SafeResourceUrl } from '@angular/platform-browser';

export const SafePipeType = {
  Html: 'html',
  Style: 'style',
  Script: 'script',
  Url: 'url',
  ResourceUrl: 'resourceUrl',
} as const;
export type SafePipeType = typeof SafePipeType[keyof typeof SafePipeType];

/**
 * Sanitize HTML
 */
@Pipe({
  name: 'safe',
})
export class SafePipe implements PipeTransform {
  /**
   * Pipe Constructor
   *
   * @param _sanitizer: DomSanitezer
   */
  // tslint:disable-next-line
  constructor(protected _sanitizer: DomSanitizer) {}

  /**
   * Transform
   *
   * @param value: string
   * @param type: string
   */
  transform(value: string, type: SafePipeType): SafeHtml | SafeStyle | SafeScript | SafeUrl | SafeResourceUrl {
    switch (type) {
      case SafePipeType.Html:
        return this._sanitizer.bypassSecurityTrustHtml(value);
      case SafePipeType.Style:
        return this._sanitizer.bypassSecurityTrustStyle(value);
      case SafePipeType.Script:
        return this._sanitizer.bypassSecurityTrustScript(value);
      case SafePipeType.Url:
        return this._sanitizer.bypassSecurityTrustUrl(value);
      case SafePipeType.ResourceUrl:
        return this._sanitizer.bypassSecurityTrustResourceUrl(value);
      default:
        return this._sanitizer.bypassSecurityTrustHtml(value);
    }
  }
}
