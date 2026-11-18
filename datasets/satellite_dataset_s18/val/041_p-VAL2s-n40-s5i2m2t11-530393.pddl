(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	instrument5 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	GroundStation3 - direction
	GroundStation10 - direction
	Star4 - direction
	GroundStation8 - direction
	Star2 - direction
	GroundStation5 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Planet17 - direction
	Phenomenon18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Phenomenon21 - direction
	Phenomenon22 - direction
	Planet23 - direction
	Planet24 - direction
	Star25 - direction
	Planet26 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation7)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation3)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 GroundStation3)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet14)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation8)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation3)
	(supports instrument4 spectrograph0)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 Star2)
	(calibration_target instrument4 GroundStation8)
	(supports instrument5 thermograph1)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation5)
	(on_board instrument4 satellite4)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Planet23)
)
(:goal (and
	(have_image Phenomenon11 spectrograph0)
	(have_image Phenomenon12 thermograph1)
	(have_image Planet13 thermograph1)
	(have_image Planet14 spectrograph0)
	(have_image Star15 thermograph1)
	(have_image Phenomenon16 spectrograph0)
	(have_image Planet17 thermograph1)
	(have_image Phenomenon18 thermograph1)
	(have_image Phenomenon19 spectrograph0)
	(have_image Planet20 thermograph1)
	(have_image Phenomenon21 spectrograph0)
	(have_image Phenomenon22 spectrograph0)
	(have_image Planet23 spectrograph0)
	(have_image Planet24 thermograph1)
	(have_image Star25 thermograph1)
	(have_image Planet26 spectrograph0)
))

)
