--[[-------------------------------------------------------------------------
  Copyright (c) 2007, Trond A Ekseth
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of oGlow nor the names of its contributors
        may be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

local _G = getfenv(0)
local oGlow = oGlow

local select = select
local ATTACHMENTS_MAX_SEND = ATTACHMENTS_MAX_SEND
local GetSendMailItem = GetSendMailItem

local udate = function(self, event, ...)
	if(not SendMailFrame:IsShown()) then return end

	for i=1, ATTACHMENTS_MAX_SEND do
		local q = select(4, GetSendMailItem(i))
		local slot = _G["SendMailAttachment"..i]

		if(q and not oGlow.preventMail) then
			oGlow(slot, q)
		elseif(slot.bc) then
			slot.bc:Hide()
		end
	end
end

local addon = CreateFrame"Frame"
addon:SetScript("OnEvent", update)

addon:RegisterEvent"MAIL_SHOW"
addon:RegisterEvent"MAIL_SEND_INFO_UPDATE"
addon:RegisterEvent"MAIL_SEND_SUCCESS"

oGlow.updateMail = update
