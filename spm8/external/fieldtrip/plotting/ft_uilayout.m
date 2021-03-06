function ft_uilayout(h, varargin)

% FT_UILAYOUT is a helper function to facilitate the layout of multiple
% usercontrol elements

% Copyright (C) 2009, Robert Oostenveld
%
% This file is part of FieldTrip, see http://www.ru.nl/neuroimaging/fieldtrip
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id: ft_uilayout.m 1824 2010-09-29 13:07:55Z crimic $

% these are used to make a selection of uicontrol elements
tag    = keyval('tag', varargin{:});
style  = keyval('style', varargin{:});

% determine all children
if ~isempty(tag) && ~isempty(style)
  c = findall(h, 'tag', tag, 'style', style);
elseif ~isempty(tag)
  c = findall(h, 'tag', tag);
elseif ~isempty(style)
  c = findall(h, 'style', style);
else
  c = findall(h);
end
c = flipud(c);
% fprintf('selected %d elements\n', numel(c));

% these are the normal features of an uicontrol
BackgroundColor         = keyval('BackgroundColor',     varargin{:});
CallBack                = keyval('CallBack',            varargin{:});
Clipping                = keyval('Clipping',            varargin{:});
Enable                  = keyval('Enable',              varargin{:});
FontAngle               = keyval('FontAngle',           varargin{:});
FontName                = keyval('FontName',            varargin{:});
FontSize                = keyval('FontSize',            varargin{:});
FontUnits               = keyval('FontUnits',           varargin{:});
FontWeight              = keyval('FontWeight',          varargin{:});
ForegroundColor         = keyval('ForegroundColor',     varargin{:});
HorizontalAlignment     = keyval('HorizontalAlignment', varargin{:});
Max                     = keyval('Max',                 varargin{:});
Min                     = keyval('Min',                 varargin{:});
Position                = keyval('Position',            varargin{:});
Selected                = keyval('Selected',            varargin{:});
String                  = keyval('String',              varargin{:});
Units                   = keyval('Units',               varargin{:});
Value                   = keyval('Value',               varargin{:});
Visible                 = keyval('Visible',             varargin{:});
Tag                     = keyval('retag',               varargin{:}); % this is to change the tag   on the selected items
Style                   = keyval('restyle',             varargin{:}); % this is to change the style on the selected items

feature = {
  'BackgroundColor'
  'CallBack'
  'Clipping'
  'Enable'
  'FontAngle'
  'FontName'
  'FontSize'
  'FontUnits'
  'FontWeight'
  'ForegroundColor'
  'HorizontalAlignment'
  'Max'
  'Min'
  'Position'
  'Selected'
  'String'
  'Units'
  'Value'
  'Visible'
  'Tag'
  'Style'
  };

for i=1:length(feature)
  val = eval(feature{i});
  if ~isempty(val)
    % fprintf('setting %s\n', feature{i});
    for j=1:length(c)
      set(c(j), feature{i}, val)
    end
  end
end

% these are special features to help with the positioning of the elements
hpos   = keyval('hpos', varargin{:});
vpos   = keyval('vpos', varargin{:});
width  = keyval('width', varargin{:});
height = keyval('height', varargin{:});

if isempty(hpos) && isempty(vpos) && isempty(width) && isempty(height)
  % re-positioning of the elements is not needed
  return
end

pos = zeros(length(c), 4);
for i=1:length(c)
  pos(i,:) = get(c(i), 'position');
end

if ~isempty(width)
  pos(:,3) = width;
end
width = pos(:,3);

if ~isempty(height)
  pos(:,4) = height;
end
height = pos(:,4);

if ~isempty(hpos)
  if isequal(hpos, 'auto')
    scale = (1 - 0.01 - 0.01*length(c)) / sum(width);
    if scale>0 && scale<1
      % fprintf('adjusting width with %f\n', scale);
      width = width*scale;
      pos(:,3) = width;
    end
    hpos = cumsum([0.01; width+0.01]);
    hpos = hpos(1:end-1);
  elseif isequal(hpos, 'align')
    hpos = pos(1,2); % the position of the first element
  elseif isequal(hpos, 'distribute')
    minpos = min(pos(:,1));
    maxpos = max(pos(:,1));
    hpos = linspace(minpos, maxpos, length(c));
  end
  pos(:,1) = hpos;
  pos(:,3) = width;
end % hpos

if ~isempty(vpos)
  if isequal(vpos, 'auto')
    scale = (1 - 0.01 - 0.01*length(c)) / sum(height);
    if scale>0 && scale<1
      % fprintf('adjusting height with %f\n', scale);
      height = height*scale;
      pos(:,4) = height;
    end
    vpos = cumsum([0.01; width]);
    vpos = vpos(1:end-1);
  elseif isequal(vpos, 'align')
    vpos = pos(1,2); % the position of the first element
  elseif isequal(vpos, 'distribute')
    minpos = min(pos(:,2));
    maxpos = max(pos(:,2));
    vpos = linspace(minpos, maxpos, length(c));
  end
  pos(:,2) = vpos;
end % vpos

% assign the new/automatic position to each of the elements
for i=1:length(c)
  set(c(i), 'position', pos(i,:));
end
