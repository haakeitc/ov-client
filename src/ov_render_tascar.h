#ifndef OV_RENDER_TASCAR
#define OV_RENDER_TASCAR

#include "ov_types.h"
#include "ovboxclient.h"
#include <tascar/session.h>

class ov_render_tascar_t : public ov_render_base_t {
public:
  ov_render_tascar_t(const std::string& deviceid);
  ~ov_render_tascar_t();
  void start_session();
  void end_session();
  void clear_stage();
  void start_audiobackend();
  void stop_audiobackend();
  void add_stage_device(const stage_device_t& stagedevice);
  void rm_stage_device(stage_device_id_t stagedeviceid);
  void set_stage_device_gain(stage_device_id_t stagedeviceid, double gain);
  void set_render_settings(const render_settings_t& rendersettings,
                           stage_device_id_t thisstagedeviceid);
  std::string get_stagedev_name(stage_device_id_t stagedeviceid) const;

private:
  void create_virtual_acoustics(xmlpp::Element* session, xmlpp::Element* e_rec,
                                xmlpp::Element* e_scene);
  FILE* h_pipe_jack;
  TASCAR::session_t* tascar;
  ovboxclient_t* ovboxclient;
};

#endif

/*
 * Local Variables:
 * mode: c++
 * compile-command: "make -C .."
 * End:
 */
