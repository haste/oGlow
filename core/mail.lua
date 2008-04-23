rocal _G = getfenv(0)
local oGlow = oGlow

local select = select
local ATTACHMENTS_MAX_SEND = ATTACHMENTS_MAX_SEND
local GetSendMailItem = GetSendMailItem

local send = function(self, event)
	if(not SendMailFrame:IsShown()) then return end

	for i=1, ATTACHMENTS_MAX_SEND do
		local link = GetSendMailItemLink(i)
		local slot = _G["SendMailAttachment"..i]
		if(link and not oGlow.preventMail) then
			local q = select(3, GetItemInfo(link))
			oGlow(slot, q)
		elseif(slot.bc) then
			slot.bc:Hide()
		end
	end
end

local inbox = function(self, event)
	local numItems = GetInboxNumItems()
	local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1

	for i=1, INBOXITEMS_TO_DISPLAY do
		local slot = _G["MailItem"..i.."Button"]
		if (index <= numItems) then
			local hq = 0
			for j=1, ATTACHMENTS_MAX_RECEIVE do
				local name = GetInboxItemLink(i, j)
				if(name) then
					-- I've always thought of (func()) to be completly useless, guess I was wrong
					hq = math.max(hq, (select(3, GetItemInfo(name))))
				end
			end

			if(hq ~= 0 and not oGlow.preventMail) then
				oGlow(slot, hq)
			elseif(slot.bc) then
				slot.bc:Hide()
			end
		end
	end
end

local addon = CreateFrame"Frame"
addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

hooksecurefunc("OpenMail_Update", function(self)
	if(not InboxFrame.openMailID) then return end

	for i=1, ATTACHMENTS_MAX_RECEIVE do
		local name = GetInboxItemLink(InboxFrame.openMailID, i)
		if(name) then
			local slot = _G["OpenMailAttachmentButton"..i]
			if(not oGlow.preventMail) then
				oGlow(slot, select(3, GetItemInfo(name)))
			elseif(slot.bc) then
				slot.bc:Hide()
			end
		end
	end
end)

addon.MAIL_SHOW = send
addon.MAIL_SEND_INFO_UPDATE = send
addon.MAIL_SEND_SUCCESS = send
addon.MAIL_INBOX_UPDATE = inbox

addon:RegisterEvent"MAIL_SHOW"
addon:RegisterEvent"MAIL_SEND_INFO_UPDATE"
addon:RegisterEvent"MAIL_SEND_SUCCESS"
addon:RegisterEvent"MAIL_INBOX_UPDATE"

oGlow.updateMail = update
