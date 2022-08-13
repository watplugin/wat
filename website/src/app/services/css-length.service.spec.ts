import { TestBed } from '@angular/core/testing';

import { CssLengthService } from './css-length.service';

describe('CssLengthService', () => {
  let service: CssLengthService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CssLengthService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
