import { Injectable } from '@angular/core';
import convertLength from 'convert-css-length';

const convertCss = convertLength('16px');

@Injectable({
  providedIn: 'root',
})
export class CssLengthService {
  constructor() {}

  convert(lengthOne: string, type: 'px' | 'em' | 'rem', fontSize: string = ''): string {
    if (fontSize) return convertCss(lengthOne, type, fontSize);
    return convertCss(lengthOne, type);
  }

  toNumber(length: string): number {
    return parseInt(length.replace(/[^0-9.]/g, ''));
  }

  convertToNumber(lengthOne: string, type: 'px' | 'em' | 'rem', fontSize: string = ''): number {
    if (fontSize) return this.toNumber(convertCss(lengthOne, type, fontSize));
    return this.toNumber(convertCss(lengthOne, type));
  }
}
