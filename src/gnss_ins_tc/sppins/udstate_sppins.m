function rtk=udstate_sppins(rtk)

% update pos vel att
rtk=udpos_sppins(rtk);

% update clk
rtk=udclk_sppins(rtk);

return