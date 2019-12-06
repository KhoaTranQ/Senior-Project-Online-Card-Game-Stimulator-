//sync_deck_remove(deck, index)
/*
**  Description
**      Deletes from specified deck a card at the specified index
**
**  Arguemnts
**      deck    obj_deck    the deck being deleted from
**      index   real        the index to delete
*/

if(global.multiplayer)
{
    var deck = argument0;
    var index = argument1;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.deckRemove);
        buffer_write(buffer, buffer_string, deck.net_id);
        buffer_write(buffer, buffer_f32, index);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending deckRemove command");
        }
    }
}
